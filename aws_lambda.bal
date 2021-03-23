import ballerinax/awslambda;
import ballerina/email;
import ballerina/io;

@awslambda:Function
function sendmail(awslambda:Context ctx, json input) returns json|error {
    string host = "smtp.gmail.com";
    string username = "xxx@gmail.com";
    string password = "xxxx!";
    string subject = "Email address is updated";
    string body = "We have detected a new email address update in the database.";
    string fromAddress = "xxxx@gmail.com";
    // Creates an SMTP client with the connection parameters, host, username,
    // and password. Default port number `465` is used over SSL with these
    // configurations.
    email:SmtpClient|error smtpClientOrError = new (host, username, password);
    if (smtpClientOrError is error) {
        io:println("Error occurred while initializing the email client.", smtpClientOrError);
    } else {
        email:SmtpClient smtpClient = smtpClientOrError;
        email:Message emailMessage = {
            to: <string> check input.email,
            subject: subject,
            body: body
        };
        // Send the email with the client.
        error? response = smtpClient->sendMessage(emailMessage);
        if (response is error) {
            return "Error while sending an email.";
        } else {
            return "Successfully sent an email";
        }
    }
}
