import org.mindrot.jbcrypt.BCrypt;
public class MakeHashes {
  public static void main(String[] args) {
    System.out.println("admin123=" + BCrypt.hashpw("admin123", BCrypt.gensalt(12)));
    System.out.println("staff123=" + BCrypt.hashpw("staff123", BCrypt.gensalt(12)));
    System.out.println("kitchen123=" + BCrypt.hashpw("kitchen123", BCrypt.gensalt(12)));
  }
}
