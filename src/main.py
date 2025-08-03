import asyncio
from tasks import IoTask, TaskMqtt, OtaTask
from tasks.task_factory import PAGE_EVENT_CONFIG, machine_events
from libs.app.config import load_config
from libs.app.display import display, PAGE_MAIN
from libs.models import RHTemp as appModel
# from libs.models import Tester as appModel

mqtt_worker: TaskMqtt | None = None
ota_worker: OtaTask | None = None
io_worker: IoTask | None = None

def on_update_event():
    global ota_worker
    print("Update event")
    if(ota_worker):
        ota_worker.start_update_process()

async def on_start_update_process():
    global mqtt_worker
    global io_worker
    print("OTA Update started")
    if mqtt_worker:
        await mqtt_worker.suspend()
    if io_worker:
        await io_worker.suspend()
    else:
        print("Io worker not found")


async def on_finish_update_process():
    global mqtt_worker
    global io_worker
    print("OTA Update finished")
    if mqtt_worker:
        await mqtt_worker.resume()
    if io_worker:
        await io_worker.resume()
    
    display.goto_page(PAGE_MAIN)
    


async def create_tasks(mode):
    global io_worker
    model = appModel()
    io_worker = IoTask(model)
    task_list = []
    task_list.append(asyncio.create_task(io_worker.execute()))
    # Crea tareas asíncronas
    if mode == PAGE_EVENT_CONFIG:
        from tasks.task_server import (
            start_web_server,
            start_dns_server,
            setup_access_point,
        )
        from libs.app.network import IP

        setup_access_point()

        task_list.append(asyncio.create_task(start_dns_server()))
        task_list.append(asyncio.create_task(start_web_server(host=IP)))

    else:
        from tasks.task_network import internet_connection
        global mqtt_worker, ota_worker

        mqtt_worker = TaskMqtt(model)
        ota_worker = OtaTask(
            on_start_update_process=on_start_update_process,
            on_finish_update_process=on_finish_update_process,
        )

        task_list.append(asyncio.create_task(internet_connection()))
        task_list.append(asyncio.create_task(mqtt_worker.execute()))
        task_list.append(asyncio.create_task(ota_worker.execute()))

    try:
        await asyncio.gather(*task_list)
    except asyncio.CancelledError:
        pass


async def main():
    general = load_config().get("general", {})
    mode = general.get("mode")

    machine_events(mode, on_update_event)

    while True:
        await create_tasks(mode)
        print("Reiniciando tareas...")
        await asyncio.sleep(2)


# Inicia el bucle principal
asyncio.run(main())
