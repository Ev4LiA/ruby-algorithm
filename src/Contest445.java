import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

public class Contest445 {
    public int findClosest(int x, int y, int z) {
        int dis1 = Math.abs(z - x);
        int dis2 = Math.abs(z - y);
        if (dis1 > dis2) {
            return 2;
        } else if (dis1 < dis2) {
            return 1;
        } else {
            return 0;
        }
    }

    public String smallestPalindrome(String s) {
        int[] count = new int[26];
        for (char c : s.toCharArray()) {
            count[c - 'a']++;
        }

        StringBuilder l = new StringBuilder();
        char m = '\0';

        for (int i = 0; i < 26; i++) {
            for (int j = 0; j < count[i] / 2; j++) {
                l.append((char)('a' + i));
            }
            if ((count[i] & 1) == 1) {
                m = (char)('a' + i);
            }
        }

        String r = new StringBuilder(l).reverse().toString();
        return l.toString() + (m != '\0' ? String.valueOf(m) : "") + r;
    }

    public int countPairs(int[] nums, int k) {
        HashMap<Integer, ArrayList<Integer>> map = new HashMap<>();
        int res = 0;
        for (int i = 0; i < nums.length; i++) {
            if (map.containsKey(nums[i])) {
                ArrayList<Integer> list = map.get(nums[i]);
                for (int j : list) {
                    if ((i * j) % k == 0) res++;
                }
                list.add(i);
            } else {
                ArrayList<Integer> list = new ArrayList<>();
                list.add(i);
                map.put(nums[i], list);
            }
        }
        return res;
    }
}
