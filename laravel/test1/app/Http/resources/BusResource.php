<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class BusResource extends JsonResource
{
public function toArray($request)
{
    return [
        'bus_id' => $this->bus_id,
        'bus_number' => $this->bus_number,
        'driver_name' => optional($this->driver)->full_name,
        'school_name' => optional($this->school)->name,
        'area' => [
            'area_id' => optional($this->area)->area_id,
            'name'    => optional($this->area)->name,
        ],
        'students_count' => $this->students->count(),
        'is_active' => (bool) $this->is_active,
    ];
}

}
