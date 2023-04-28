table 80500 "PTEAP API AP Header"
{
    DataClassification = CustomerContent;
    Caption = 'API AP Header';
    TableType = Temporary;

    fields
    {
        field(1; "Claim Number"; Code[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Claim Number';
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(3; "Bill-To Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(4; "Claimant Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Claimant Name';
        }
        field(5; "SSN"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'SSN';
        }
        field(6; "DOB"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'DOB';
        }
        field(7; "Claims Manager"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Claims Manager';
        }
        field(8; "Referral Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Referral Date';
        }
    }

    keys
    {
        key(Key1; "Claim Number")
        {
            Clustered = true;
        }
    }

    procedure ProcessAPInterface(): Text
    var
        SalesHeader: Record "Sales Header";
        CreatedLbl: Label '%1 %2 Created', Comment = '%1 = doc type %2 = doc no';
    begin
        // CreateTempAPEntries(TempAPEntry, '');
        SalesHeader.PTEGetSalesHeader("Sales Document Type"::Invoice, Rec);
        // CreateSalesLines(SalesHeader, TempAPEntry);
        exit(StrSubstNo(CreatedLbl, SalesHeader."Document Type", SalesHeader."No."));
    end;

    // local procedure CreateTempAPEntries(var TempAPEntry: Record "PTEAP AP Entry"; LinesText: Text)
    // var
    //     Item: Record Item;
    //     Lines: JsonArray;
    //     Line: JsonToken;
    //     jObject: JsonObject;
    //     jToken: JsonToken;
    // begin
    //     TempAPEntry.Init();
    //     TempAPEntry."Claim Number" := "Claim Number";
    //     TempAPEntry."Sell-to Customer No." := "Sell-to Customer No.";
    //     TempAPEntry."Bill-To Customer No." := "Bill-To Customer No.";
    //     TempAPEntry."Claimant Name" := "Claimant Name";
    //     TempAPEntry."SSN" := SSN;
    //     TempAPEntry."DOB" := DOB;
    //     TempAPEntry."Claims Manager" := "Claims Manager";
    //     TempAPEntry."Referral Date" := "Referral Date";
    //     TempAPEntry."Document Type" := TempAPEntry."Document Type"::Invoice;
    //     TempAPEntry."Document No." := 'temp';
    //     if Lines.ReadFrom(LinesText) then
    //         foreach Line in Lines do begin
    //             TempAPEntry."Line No." += 1;
    //             jObject := Line.AsObject();

    //             jObject.Get('task_code', jToken);
    //             GetItem(Item, jToken.AsValue().AsText());
    //             TempAPEntry."Task Code" := Item."No.";

    //             jObject.Get('task_activity', jToken);
    //             TempAPEntry."Task/Activity" := jToken.AsValue().AsText();
    //             jObject.Get('task_date', jToken);
    //             TempAPEntry."Task Date" := jToken.AsValue().AsDate();
    //             jObject.Get('units', jToken);
    //             TempAPEntry.Units := jToken.AsValue().AsDecimal();
    //             jObject.Get('rate', jToken);
    //             TempAPEntry.Rate := jToken.AsValue().AsDecimal();
    //             jObject.Get('amount', jToken);
    //             TempAPEntry.Amount := jToken.AsValue().AsDecimal();
    //             jObject.Get('description', jToken);
    //             TempAPEntry.Description := jToken.AsValue().AsText();
    //             TempAPEntry.Insert();
    //         end;
    // end;
}