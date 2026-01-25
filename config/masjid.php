<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Approval Threshold
    |--------------------------------------------------------------------------
    |
    | Expense transactions above this amount require Ketua approval.
    | Configurable via .env: APPROVAL_THRESHOLD=1000000
    |
    */
    'approval_threshold' => env('APPROVAL_THRESHOLD', 1000000),

    /*
    |--------------------------------------------------------------------------
    | User Roles
    |--------------------------------------------------------------------------
    |
    | Defined roles for the application
    |
    */
    'roles' => [
        'super_admin' => 'Super Admin',
        'ketua' => 'Ketua',
        'bendahara' => 'Bendahara',
        'marbot' => 'Marbot',
    ],
];
