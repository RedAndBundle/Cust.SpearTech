Page 80601 "PTEPI API PI Header"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'piHeader';
    EntitySetName = 'piHeaders';
    ODataKeyFields = SystemId;
    PageType = API;
    APIPublisher = 'speartech';
    APIGroup = 'pi';
    APIVersion = 'v2.0';
    SourceTable = "PTEPI API PI Header";
    SourceTableTemporary = true;
    Extensible = false;
    ChangeTrackingAllowed = true;

    // http://bc230-us:7048/bc/api/speartech/pi/v2.0/companies(43a32486-b6d6-ee11-9051-6045bdc89dc0)/piHeaders?tenant=default
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { ApplicationArea = Basic, Suite; }
                field(invoiceDate; Rec."Invoice Date") { ApplicationArea = Basic, Suite; }
                field(invoiceNo; Rec."Invoice No.") { ApplicationArea = Basic, Suite; }
                field(insuredNo; Rec."Insured No.") { ApplicationArea = Basic, Suite; }
                field(brokerNo; Rec."Broker No.") { ApplicationArea = Basic, Suite; }
                field(paymentsReceived; Rec."Payments Received") { ApplicationArea = Basic, Suite; }
                field(balance; Rec."Balance") { ApplicationArea = Basic, Suite; }
                field(spearNo; Rec."Spear No.") { ApplicationArea = Basic, Suite; }
                field(policyNumber; Rec."Policy Number") { ApplicationArea = Basic, Suite; }
                field(policyEffectiveDate; Rec."Policy Effective Date") { ApplicationArea = Basic, Suite; }
                field(policyExpirationDate; Rec."Policy Expiration Date") { ApplicationArea = Basic, Suite; }
                field(policyType; Rec."Policy Type") { ApplicationArea = Basic, Suite; }
                field(paymentDueDate; Rec."Payment Due Date") { ApplicationArea = Basic, Suite; }
                field(policyTotalPremium; Rec."Policy Total Premium") { ApplicationArea = Basic, Suite; }
                field(policyTotalCharges; Rec."Policy Total Charges") { ApplicationArea = Basic, Suite; }
                field(policyTotalCost; Rec."Policy Total Cost") { ApplicationArea = Basic, Suite; }
            }
            part(piLines; "PTEPI API PI Line")
            {
                EntityName = 'piLine';
                EntitySetName = 'piLines';
                SubPageLink = "Policy Number" = field("Policy Number"), "Spear No." = field("Spear No.");
            }
        }
    }

    var
        Result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Setup: Record "PTEPI Spear PI Setup";
    begin
        Rec.TestField("Insured No.");
        Rec.TestField("Broker No.");
        Rec.TestField("Policy Number");
        Rec.TestField("Spear No.");
        Setup.Get();
        Setup.TestField("Item Template");
        Result := Rec.ProcessAPInterface();
    end;

    // http://bc230-us:7048/bc/api/speartech/pi/v2.0/companies(43a32486-b6d6-ee11-9051-6045bdc89dc0)/piHeaders(ecca1e29-8815-ee11-9e03-a6b3ed45dbcc)
    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(Rec.GetFromSystemId(Rec.GetFilter(SystemId)));
    end;

    // http://bc230-us:7048/bc/api/speartech/pi/v2.0/companies(43a32486-b6d6-ee11-9051-6045bdc89dc0)/piHeaders(ecca1e29-8815-ee11-9e03-a6b3ed45dbcc)/Microsoft.NAV.post?tenant=default
    [ServiceEnabled]
    [Scope('Cloud')]
    procedure Post(var ActionContext: WebServiceActionContext)
    begin
        Rec.Post();
    end;
}
