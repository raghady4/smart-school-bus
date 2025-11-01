<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;
use App\Models\Bus;

class Device extends Model
{


    protected $primaryKey = 'devices_id';

    protected $fillable = [
        'bus_id',
        'name',
        'device_type',
        'device_identifier',
    ];

    public function bus()
    {
        return $this->belongsTo(Bus::class, 'bus_id', 'bus_id');
    }

    public function sensor()
    {
        return $this->hasOne(Sensor::class, 'device_id', 'devices_id');
    }

    // public function nfcLog()
    // {
    //     return $this->hasOne(NfCLog::class, 'device_id', 'devices_id');
    // }
}
