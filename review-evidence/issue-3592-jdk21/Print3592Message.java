import org.mockito.internal.configuration.DefaultDoNotMockEnforcer;

class Print3592Message {
    public static void main(String[] args) throws Exception {
        Class<?> type = Class.forName(
                "org.mockitousage.annotation.DoNotMockMessageTest$CustomType");
        System.out.println(new DefaultDoNotMockEnforcer().checkTypeForDoNotMockViolation(type));
    }
}
