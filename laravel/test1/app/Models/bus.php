<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Bus extends Model
{
    protected $primaryKey = 'bus_id';

    protected $fillable = [
        'bus_number', 'driver_id', 'school_id', 'color', 'area_id', 'is_active'
    ];

    public function driver()
    {
        return $this->belongsTo(User::class, 'driver_id', 'user_id');
    }

    public function school()
    {
        return $this->belongsTo(School::class, 'school_id', 'school_id');
    }

    public function area()
    {
        return $this->belongsTo(Area::class, 'area_id', 'area_id');
    }

    public function students()
    {
        return $this->hasMany(Student::class, 'bus_id', 'bus_id');
    }
        public function devices()
    {
        return $this->hasMany(Device::class, 'device_id', 'device_id');
    }
}
