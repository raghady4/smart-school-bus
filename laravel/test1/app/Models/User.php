<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class User extends Authenticatable implements MustVerifyEmail
{
    use HasApiTokens, Notifiable, HasFactory;

    protected $primaryKey = 'user_id';

    protected $fillable = [
        'full_name', 'email', 'password', 'phone', 'role', 'is_active'
    ];

    protected $hidden = [
        'password', 'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'is_active' => 'boolean',
    ];


  public function devices()
{
    return $this->hasMany(Device::class);
}
public function payments()
{
    return $this->hasMany(Payment::class, 'user_id', 'user_id');
}
public function students()
{
    return $this->hasMany(student::class, 'user_id', 'user_id');
}

}
