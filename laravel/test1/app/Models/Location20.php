<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Location20 extends Model
{
    use HasFactory;
    protected $table ='location20s';

    protected $fillable = [
        'tracker_id',
         'latitude',
          'longitude',
           'altitude',
           'accuracy',
            'type',
             'timestamp'
    ];
}
