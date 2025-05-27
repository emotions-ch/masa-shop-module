component
  accessors="false"
  displayname="BCrypt"
  hint="BCrypt"
  output="false"
{
  /**
   * @hint Initialize component
   */
  public component function init() output=false {
    return this;
  }

  /**
   * @hint Returns an instance of the BCrypt class
   * @return org.mindrot.jbcrypt.BCrypt
   */
  public any function getBCrypt() {
    if (NOT structKeyExists(application, 'bcryptSingleton')) {
      local.LIB_PATH = getDirectoryFromPath(getCurrentTemplatePath()) & "../lib/jbcrypt-0.4.jar";
      application.bcryptSingleton = createObject('java', 'org.mindrot.jbcrypt.BCrypt', local.LIB_PATH);
    }
    return application.bcryptSingleton;
  }

  /**
   * @hint Hashes a string using BCrypt, given the number of logRounds
   * @str String to hash
   * @logRounds Number of logRounds
   * @return Hashed string
   */
  public string function toBCryptHash(
    required string str,
    numeric logRounds=10
  ) {
    local.hash = getBCrypt().hashpw(JavaCast('string', arguments.str), getBCrypt().gensalt(JavaCast('int', arguments.logRounds)));
    return local.hash;
  }

  /**
   * @hint Compares a string to a BCrypt hash
   * @str String to compare
   * @hash Hash to compare
   * @return Boolean, wether the string matches the hash
   */
  public boolean function checkBCryptHash(
    required string str,
    required string hash
  ) {
    local.match = false;
    try {
      local.match = getBCrypt().checkpw(JavaCast('string', arguments.str), JavaCast('string', arguments.hash));
    } catch(any e) {
      local.match = false;
    }
    return local.match;
  }
}