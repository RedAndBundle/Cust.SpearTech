codeunit 50100 "PTE Azure Blob Mgt."
{

    procedure GetBlobFromAzure(Value: Code[50]) ResponseText: InStream
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
    begin
        if not Client.Get('https://vgblobstoragepublic.blob.core.windows.net/fornavsetup/EOR from IMS.pdf', ResponseMessage) then // ToDo, Dynamically build URL based on Check No.
                                                                                                                                  //        if not Client.Get('https://spearclaimsdevdocuments.blob.core.windows.net/spear-claimant/EOR from IMS.pdf', ResponseMessage) then // ToDo, Dynamically build URL based on Check No.
            Error('The call to the web service failed.');

        ResponseMessage.Content().ReadAs(ResponseText);
    end;
}