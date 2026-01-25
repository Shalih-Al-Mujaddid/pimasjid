<?php

namespace App\Exports;

use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;

class QurbanExport implements FromView, ShouldAutoSize
{
    protected $viewData;

    public function __construct($viewData)
    {
        $this->viewData = $viewData;
    }

    public function view(): View
    {
        // Reuse the PDF view for consistency, Excel parser handles table structures well
        // We might need to ensure CSS doesn't break it, but usually basic tables are fine.
        return view('exports.qurban_pdf', $this->viewData);
    }
}
