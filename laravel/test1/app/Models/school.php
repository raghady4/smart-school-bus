<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class School extends Model
{
    protected $primaryKey = 'school_id';
    protected $fillable = ['name', 'area_id','admin_id'];

    public function buses()
    {
        return $this->hasMany(Bus::class, 'school_id', 'school_id');
    }

    public function students()
    {
        return $this->hasMany(Student::class, 'school_id', 'school_id');
    }

    public function area()
    {
        return $this->belongsTo(Area::class, 'area_id', 'area_id');
    }

     public function admin()
    {
        return $this->belongsTo(User::class, 'admin_id', 'user_id');
    }
}
