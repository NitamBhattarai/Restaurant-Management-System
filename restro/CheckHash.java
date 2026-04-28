import org.mindrot.jbcrypt.BCrypt;
public class CheckHash {
  public static void main(String[] args) {
    String hash = "$2a$12$Y5wNKBNDFQCh1SUb7mBsP.YA/2j/X5mZe6gVbNc9Ym0jw3OqSA5Aq";
    System.out.println(BCrypt.checkpw("admin123", hash));
    System.out.println(BCrypt.checkpw("staff123", hash));
    System.out.println(BCrypt.checkpw("kitchen123", hash));
  }
}
