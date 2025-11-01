<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class NfcLog extends Model
{
    use HasFactory;

    protected $table = 'nfc_logs';
    protected $primaryKey = 'nfc_logs_id';
    public $incrementing = true;
    protected $keyType = 'int';

    protected $fillable = [
        'student_id',
        'bus_id',
        'is_active',
        'timestamp',
    ];

    public function student()
    {
        return $this->belongsTo(Student::class, 'student_id', 'student_id');
    }

    public function details()
    {
        return $this->hasMany(NFCDetail::class, 'log_id', 'nfc_logs_id');
    }
}
