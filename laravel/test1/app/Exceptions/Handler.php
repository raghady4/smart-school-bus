<?php

namespace App\Exceptions;

use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Throwable;

class Handler extends ExceptionHandler
{
    /**
     * قائمة الاستثناءات التي لا يجب الإبلاغ عنها.
     */
    protected $dontReport = [
        //
    ];

    /**
     * قائمة المدخلات التي لا يجب عرضها في أخطاء التحقق.
     */
    protected $dontFlash = [
        'current_password',
        'password',
        'password_confirmation',
    ];

    /**
     * التعامل مع الاستثناءات.
     */
    public function register(): void
    {
        $this->reportable(function (Throwable $e) {
            //
        });
    }
}
