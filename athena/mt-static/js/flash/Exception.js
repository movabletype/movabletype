/**
 * Create a new Exception object.
 * name: The name of the exception.
 * message: The exception message.
 */
function Exception(name, message)
{
    if (name)
        this.name = name;
    if (message)
        this.message = message;
}

/**
 * Set the name of the exception. 
 */
Exception.prototype.setName = function(name)
{
    this.name = name;
}

/**
 * Get the exception's name. 
 */
Exception.prototype.getName = function()
{
    return this.name;
}

/**
 * Set a message on the exception. 
 */
Exception.prototype.setMessage = function(msg)
{
    this.message = msg;
}

/**
 * Get the exception message. 
 */
Exception.prototype.getMessage = function()
{
    return this.message;
}

