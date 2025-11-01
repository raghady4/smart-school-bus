<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Device;

class Sensor extends Model
{
    use HasFactory;

    protected $primaryKey = 'sensor_id';

    protected $fillable = [
        'device_id',
        'type',
        'status',
        'data'
    ];

    protected $casts =[
        'data' => 'array'
    ];

    public function device()
    {
        return $this->belongsTo(Device::class, 'device_id', 'devices_id');
    }
}
