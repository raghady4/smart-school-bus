<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Gate;

class AuthServiceProvider extends ServiceProvider
{
    protected $policies = [];

    public function boot()
    {
        $this->registerPolicies();

        // إيقاف auto-discovery للـ Policies نهائيًا
        Gate::guessPolicyNamesUsing(function () {
            return null;
        });
    }
}
