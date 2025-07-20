import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Contest153 {
    public int reverseDegree(String s) {
        int count = 0;
        for(int i = 0; i < s.length(); i++) {
            count += ('z' - s.charAt(i) + 1) * (i + 1);
        }
        return count;
    }

    public int maxActiveSectionsAfterTrade(String s) {
        List<int[]> sections = new ArrayList<>();
        int count = 1;

        for (int i = 0; i < s.length() - 1; i++) {
            if (s.charAt(i) == s.charAt(i + 1)) {
                count++;
            } else {
                sections.add(new int[]{s.charAt(i), count});
                count = 1;
            }
        }
        sections.add(new int[]{s.charAt(s.length() - 1), count});

        int active = 0;
        for (int[] section : sections) {
            if (section[0] == '1') {
                active += section[1];
            }
        }

        if (sections.size() <= 2) {
            return active;
        }

        int max = active;
        for (int i = 1; i < sections.size() - 1; i++) {
            int[] section = sections.get(i);

            if (section[0] == '1' && sections.get(i - 1)[0] == '0' && sections.get(i + 1)[0] == '0') {
                int newSections = active + sections.get(i - 1)[1] + sections.get(i + 1)[1];

                max = Math.max(max, newSections);
            }
        }

        return max;
    }

    public long minimumCost(int[] nums, int[] cost, int k) {
        int n = nums.length;

        int[] prefixNums = new int[n + 1];
        int[] prefixCost = new int[n + 1];

        for (int i = 0; i < n; i++) {
            prefixNums[i + 1] = prefixNums[i] + nums[i];
            prefixCost[i + 1] = prefixCost[i] + cost[i];
        }

        int[] dp = new int[n + 1];
        Arrays.fill(dp, Integer.MAX_VALUE);
        dp[0] = 0;

        for (int i = 1; i <= n; i++) {
            for (int j = 0; j < i; j++) {
                int sumNums = prefixNums[i] - prefixNums[j];
                int sumCost = prefixCost[i] - prefixCost[j];
                int order = j == 0 ? 1 : (dp[j] != Integer.MAX_VALUE ? (j + 1) : 1);

                int subarrayCost = (sumNums + k * order) * sumCost;

                if (dp[j] != Integer.MAX_VALUE) {
                    dp[i] = Math.min(dp[i], dp[j] + subarrayCost);
                }
            }
        }

        return dp[n];
    }
}
