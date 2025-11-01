<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class NFCDetail extends Model
{
    use HasFactory;

    protected $table ='nfc_details';
    protected $primaryKey = 'nfc_details_id';

    protected $fillable = [
        'log_id',
        'action_type',
        'action_time',
    ];

    public function nfcLog()
    {
        return $this->belongsTo(NfcLog::class, 'log_id', 'nfc_logs_id');
    }
}
