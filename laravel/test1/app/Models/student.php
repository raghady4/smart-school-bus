<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Student extends Model
{
    protected $primaryKey = 'student_id';

    protected $fillable = [
        'full_name', 'photo', 'area_id', 'school_id', 'school_location',
        'nfc_logs_id', 'parent_id', 'bus_id', 'status','address'
    ];

    public function parent()
    {
        return $this->belongsTo(User::class, 'parent_id', 'user_id');
    }

    public function school()
    {
        return $this->belongsTo(School::class, 'school_id', 'school_id');
    }

     public function area()
    {
        return $this->belongsTo(Areas::class, 'area_id', 'area_id');
    }

    public function bus()
    {
        return $this->belongsTo(Bus::class, 'bus_id', 'bus_id');
    }

      public function NfcLogs()
    {
        return $this->belongsTo(NfcLogs::class, 'nfc_logs_id', 'nfc_logs_id');
    }

}
