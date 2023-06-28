
pageextension 80402 "PTE Vendor Card" extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("PTE Combine Payments"; Rec."PTE Combine Payments")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if check payments will be combined into one check for this vendor.';
            }
        }
    }
}