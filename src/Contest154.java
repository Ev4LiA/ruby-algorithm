import java.util.HashSet;
import java.util.Set;

public class Contest154 {
    public int minOperations(int[] nums, int k) {
        int sum = 0;
        for (int num : nums) {
            sum += num;
        }
        return sum % k;
    }

    public int uniqueXorTriplets(int[] nums) {
        Set<Integer> uniqueXORs = new HashSet<>();

        for (int num : nums) {
            uniqueXORs.add(num);
        }

        boolean[][] dp = new boolean[4][2048];
        dp[0][0] = true;

        for (int num : nums) {
            for (int k = 2; k >= 0; k--) {
                for (int b = 0; b < 2048; b++) {
                    if (dp[k][b]) {
                        dp[k + 1][b ^ num] = true;
                    }
                }
            }
        }

        for (int b = 0; b < 2048; b++) {
            if (dp[3][b]) {
                uniqueXORs.add(b);
            }
        }

        return uniqueXORs.size();
    }
}
