import java.util.HashMap;
import java.util.Map;

public class Contest443 {
    public int[] minCosts(int[] cost) {
        int[] res = new int[cost.length];
        int min = Integer.MAX_VALUE;

        for (int i = 0; i < cost.length; i++) {
            min = Math.min(min, cost[i]);
            res[i] = min;
        }
        return res;
    }

    // Longest Palindrome After Substring Concatenation I
    public static int longestPalindrome(String s, String t) {
        int maxLen = 0;

        for (int i = 0; i < s.length(); i++) {
            for (int j = i + 1; j <= s.length(); j++) {
                String sSub = s.substring(i, j);

                for (int k = 0; k < t.length(); k++) {
                    for (int l = k + 1; l <= t.length(); l++) {
                        String tSub = t.substring(k, l);
                        String combined = sSub + tSub;
                        if (isPalindrome(combined)) {
                            maxLen = Math.max(maxLen, combined.length());
                        }
                    }
                }
            }
        }

        for (int i = 0; i < s.length(); i++) {
            for (int j = i + 1; j <= s.length(); j++) {
                String sSub = s.substring(i, j);
                if (isPalindrome(sSub)) {
                    maxLen = Math.max(maxLen, sSub.length());
                }
            }
        }

        for (int i = 0; i < t.length(); i++) {
            for (int j = i + 1; j <= t.length(); j++) {
                String tSub = t.substring(i, j);
                if (isPalindrome(tSub)) {
                    maxLen = Math.max(maxLen, tSub.length());
                }
            }
        }

        return maxLen;
    }

    private static boolean isPalindrome(String str) {
        int left = 0;
        int right = str.length() - 1;
        while (left < right) {
            if (str.charAt(left) != str.charAt(right)) {
                return false;
            }
            left++;
            right--;
        }
        return true;
    }
}
