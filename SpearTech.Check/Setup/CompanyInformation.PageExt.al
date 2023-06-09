pageextension 80401 "PTE Company Information" extends "Company Information"
{
    layout
    {
        addlast(content)
        {
            group(PTESpear)
            {
                Caption = 'SpearTech';
                field(PTESystemId; Rec.SystemId)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the company''s system id. You need this for the API communication.';
                }
            }
        }
    }
}