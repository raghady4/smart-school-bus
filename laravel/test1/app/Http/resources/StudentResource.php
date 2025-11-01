<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class StudentResource extends JsonResource
{
 public function toArray($request)
{
    return [
        'student_id' => $this->student_id,
        'full_name' => $this->full_name,
        'photo' => $this->photo,
        'address' => $this->address,
        'nfc_logs_id' => $this->nfc_logs_id,
        'status' => $this->status,

        'parent' => [
            'user_id' => optional($this->parent)->user_id,
            'full_name' => optional($this->parent)->full_name,
            'phone' => optional($this->parent)->phone,
        ],

        'bus' => [
            'bus_id' => optional($this->bus)->bus_id,
            'number' => optional($this->bus)->bus_number,
            'color' => optional($this->bus)->color,
        ],

        'created_at' => $this->created_at->toDateTimeString(),
    ];
}

}
