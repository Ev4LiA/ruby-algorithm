import java.lang.reflect.Array;
import java.util.*;

public class Contest447 {
    public int countCoveredBuildings(int n, int[][] buildings) {
        Arrays.sort(buildings, (a, b) -> {
            if (a[0] != b[0]) {
                return Integer.compare(a[0], b[0]);
            } else {
                return Integer.compare(a[1], b[1]);
            }
        });

        int count = 0;
        HashMap<Integer, List<Integer>> rowMap = new HashMap<>();
        HashMap<Integer, List<Integer>> colMap = new HashMap<>();
        for (int[] building : buildings) {
            int row = building[0];
            int col = building[1];

            rowMap.computeIfAbsent(row, k -> new ArrayList<>()).add(col);
            colMap.computeIfAbsent(col, k -> new ArrayList<>()).add(row);
        }

        for(int[] building : buildings) {
            int row = building[0];
            int col = building[1];
            if (row == 0 || row == n || col == 0 || col == n) {
                continue;
            }

            List<Integer> cols = rowMap.get(row);
            List<Integer> rows = colMap.get(col);
            if (cols.size() < 3 || rows.size() < 3) {
                continue;
            }

            int colIndex = cols.indexOf(col);
            int rowIndex = rows.indexOf(row);
            if (colIndex > 0 && colIndex < cols.size() - 1 && rowIndex > 0 && rowIndex < rows.size() - 1) {
                count++;
            }
        }
        return count;
    }

    public int[] concatenatedDivisibility(int[] nums, int k) {
        List<Integer> resultList = new ArrayList<>();
        List<Integer> currentPermutation = new ArrayList<>();
        boolean[] used = new boolean[nums.length];
        permute(nums, k, used, currentPermutation, resultList);
        return resultList.stream().mapToInt(Integer::intValue).toArray();
    }

    private void permute(int[] nums, int k, boolean[] used, List<Integer> currentPermutation, List<Integer> resultList) {
        if (currentPermutation.size() == nums.length) {
            long concatenatedNumber = 0;
            for (int num : currentPermutation) {
                concatenatedNumber = concatenatedNumber * (long) Math.pow(10, String.valueOf(num).length()) + num;
            }
            if (concatenatedNumber % k == 0) {
                if (concatenatedNumber <= Integer.MAX_VALUE && concatenatedNumber >= Integer.MIN_VALUE) {
                    resultList.add((int) concatenatedNumber);
                }
            }
            return;
        }

        for (int i = 0; i < nums.length; i++) {
            if (!used[i]) {
                used[i] = true;
                currentPermutation.add(nums[i]);
                permute(nums, k, used, currentPermutation, resultList);
                currentPermutation.remove(currentPermutation.size() - 1);
                used[i] = false;
            }
        }
    }

    public int minDominoRotations(int[] tops, int[] bottoms) {
        int n = tops.length;
        for (int i = 1, top = 0, bot = 0; i < n && (tops[i] == tops[0] || bottoms[i] == tops[0]); i++) {
            if (tops[i] != tops[0]) {
                top++;
            }
            if (bottoms[i] != tops[0]) {
                bot++;
            }
            if (i == n - 1) {
                return Math.min(top, bot);
            }
        }

        for (int i = 1, top = 0, bot = 0; i < n && (tops[i] == bottoms[0] || bottoms[i] == bottoms[0]); i++) {
            if (tops[i] != bottoms[0]) {
                top++;
            }
            if (bottoms[i] != bottoms[0]) {
                bot++;
            }
            if (i == n - 1) {
                return Math.min(top, bot);
            }
        }
        return -1;
    }
}
