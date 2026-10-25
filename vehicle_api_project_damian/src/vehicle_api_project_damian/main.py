from fastapi import FastAPI, HTTPException  # type: ignore[reportMissingImports]
from pydantic import BaseModel # type: ignore[reportMissingImports]
from typing import Dict

app = FastAPI(title="Vehicle Manufacturer API")


# ----------------------
# Models
# ----------------------

class Manufacturer(BaseModel):
    id: int
    name: str
    country: str


class Vehicle(BaseModel):
    id: int
    manufacturer_id: int
    model: str
    year: int


# ----------------------
# In-Memory Databases
# ----------------------

manufacturers: Dict[int, Manufacturer] = {}
vehicles: Dict[int, Vehicle] = {}


# ======================
# Manufacturer Endpoints
# ======================

@app.post("/manufacturers/")
def create_manufacturer(manufacturer: Manufacturer):

    if manufacturer.id in manufacturers:
        raise HTTPException(
            status_code=400,
            detail="Manufacturer ID already exists"
        )

    manufacturers[manufacturer.id] = manufacturer
    return manufacturer


@app.get("/manufacturers/")
def get_manufacturers():
    return list(manufacturers.values())


@app.get("/manufacturers/{manufacturer_id}")
def get_manufacturer(manufacturer_id: int):

    if manufacturer_id not in manufacturers:
        raise HTTPException(
            status_code=404,
            detail="Manufacturer not found"
        )

    return manufacturers[manufacturer_id]


@app.put("/manufacturers/{manufacturer_id}")
def update_manufacturer(
    manufacturer_id: int,
    updated_manufacturer: Manufacturer
):

    if manufacturer_id not in manufacturers:
        raise HTTPException(
            status_code=404,
            detail="Manufacturer not found"
        )

    manufacturers[manufacturer_id] = updated_manufacturer
    return updated_manufacturer


@app.delete("/manufacturers/{manufacturer_id}")
def delete_manufacturer(manufacturer_id: int):

    if manufacturer_id not in manufacturers:
        raise HTTPException(
            status_code=404,
            detail="Manufacturer not found"
        )

    del manufacturers[manufacturer_id]

    return {
        "message": "Manufacturer deleted successfully"
    }


# ======================
# Vehicle Endpoints
# ======================

@app.post("/vehicles/")
def create_vehicle(vehicle: Vehicle):

    if vehicle.id in vehicles:
        raise HTTPException(
            status_code=400,
            detail="Vehicle ID already exists"
        )

    if vehicle.manufacturer_id not in manufacturers:
        raise HTTPException(
            status_code=404,
            detail="Manufacturer does not exist"
        )

    vehicles[vehicle.id] = vehicle

    return vehicle


@app.get("/vehicles/")
def get_vehicles():
    return list(vehicles.values())


@app.get("/vehicles/{vehicle_id}")
def get_vehicle(vehicle_id: int):

    if vehicle_id not in vehicles:
        raise HTTPException(
            status_code=404,
            detail="Vehicle not found"
        )

    return vehicles[vehicle_id]


@app.put("/vehicles/{vehicle_id}")
def update_vehicle(
    vehicle_id: int,
    updated_vehicle: Vehicle
):

    if vehicle_id not in vehicles:
        raise HTTPException(
            status_code=404,
            detail="Vehicle not found"
        )

    if updated_vehicle.manufacturer_id not in manufacturers:
        raise HTTPException(
            status_code=404,
            detail="Manufacturer does not exist"
        )

    vehicles[vehicle_id] = updated_vehicle

    return updated_vehicle


@app.delete("/vehicles/{vehicle_id}")
def delete_vehicle(vehicle_id: int):

    if vehicle_id not in vehicles:
        raise HTTPException(
            status_code=404,
            detail="Vehicle not found"
        )

    del vehicles[vehicle_id]

    return {
        "message": "Vehicle deleted successfully"
    }