<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class AreaResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'area_id'   => $this->area_id, 
            'name' => $this->name,
        ];
    }
}
