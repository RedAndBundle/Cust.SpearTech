
tableextension 80402 "PTE Vendor" extends Vendor
{
    fields
    {
        field(80400; "PTE Combine Payments"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Combine Payments';
        }
    }
}