Page 80501 "PTEAP API AP Header"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'apHeader';
    EntitySetName = 'apHeaders';
    ODataKeyFields = SystemId;
    PageType = API;
    APIPublisher = 'speartech';
    APIGroup = 'ap';
    APIVersion = 'v2.0';
    SourceTable = "PTEAP API AP Header";
    SourceTableTemporary = true;

    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { ApplicationArea = Basic; }
                field(sellto_customer_no; Rec."Sell-to Customer No.") { ApplicationArea = Basic; }
                field(bill_to_customer_no; Rec."Bill-To Customer No.") { ApplicationArea = Basic; }
                field(claim_number; Rec."Claim Number") { ApplicationArea = Basic; }
                field(claimant_name; Rec."Claimant Name") { ApplicationArea = Basic; }
                field(ssn; Rec.SSN) { ApplicationArea = Basic; }
                field(dob; Rec.DOB) { ApplicationArea = Basic; }
                field(claims_manager; Rec."Claims Manager") { ApplicationArea = Basic; }
                field(referral_date; Rec."Referral Date") { ApplicationArea = Basic; }
                field(result; Result) { ApplicationArea = Basic; }
            }
            part(apLines; "PTEAP API AP Line")
            {
                EntityName = 'apLine';
                EntitySetName = 'apLines';
                SubPageLink = "Claim Number" = field("Claim Number");
            }
        }
    }

    var
        Result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Setup: Record "PTEAP Spear AP Setup";
        TempAPIAPLine: Record "PTEAP API AP Line" temporary;
        Vendor: Record Vendor;
    begin
        Rec.TestField("Sell-to Customer No.");
        Rec.TestField("Claim Number");
        Setup.Get();
        Setup.TestField("Item Template");
        Result := Rec.ProcessAPInterface();
    end;
}
