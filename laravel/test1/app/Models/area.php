<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Area extends Model
{
    use HasFactory;

    protected $primaryKey = 'area_id';
    protected $fillable = ['name', 'description'];

    public function schools()
    {
        return $this->hasMany(School::class, 'area_id', 'area_id');
    }

    public function buses()
    {
        return $this->hasMany(Bus::class, 'area_id', 'area_id');
    }

     public function students()
    {
        return $this->hasMany(Student::class, 'area_id', 'area_id');
    }
}
