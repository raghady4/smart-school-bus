<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class SchoolResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'school_id' => $this->school_id,
            'name' => $this->name,
            'location' => $this->location,
            'area' => [
                'area_id' => $this->area->area_id ?? null,
                'name' => $this->area->name ?? null,
                'description' => $this->area->description ?? null,
            ],
        ];
    }
}
