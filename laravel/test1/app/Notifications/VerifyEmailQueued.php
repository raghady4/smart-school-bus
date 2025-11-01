<?php

// namespace App\Notifications;

// use Illuminate\Auth\Notifications\VerifyEmail;
// use Illuminate\Bus\Queueable;
// use Illuminate\Contracts\Queue\ShouldQueue;
// use Illuminate\Notifications\Messages\MailMessage;
// use Illuminate\Support\Facades\URL;

// class VerifyEmailQueued extends VerifyEmail implements ShouldQueue
// {
//     use Queueable;

//     /**
//      * Get the mail representation of the notification.
//      */
//     public function toMail($notifiable)
//     {
//         $verificationUrl = URL::temporarySignedRoute(
//             'verification.verify',
//             now()->addMinutes(60),
//             [
//                 'id' => $notifiable->getKey(),
//                 'hash' => sha1($notifiable->email),
//             ]
//         );

//         return (new MailMessage)
//             ->subject('Verify Email Address')
//             ->line('Please click the button below to verify your email address.')
//             ->action('Verify Email Address', $verificationUrl)
//             ->line('If you did not create an account, no further action is required.');
//     }
// }


namespace App\Notifications;

use Illuminate\Auth\Notifications\VerifyEmail;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Support\Facades\URL;

class VerifyEmailQueued extends VerifyEmail implements ShouldQueue
{
    use Queueable;

    /**
     * بناء رسالة التحقق المرسلة للمستخدم
     */
    public function toMail($notifiable)
    {
        // نعمل رابط مؤقت صالح لمدة 60 دقيقة
        $verificationUrl = URL::temporarySignedRoute(
            'verification.verify',
            now()->addMinutes(60),
            [
                'id'   => $notifiable->getKey(),
                'hash' => sha1($notifiable->email),
            ]
        );

        return (new MailMessage)
            ->subject('Verify Your Email Address')
            ->line('Click the button below to verify your email address:')
            ->action('Verify Email Address', $verificationUrl)
            ->line('If you did not create an account, no further action is required.');
    }
}
