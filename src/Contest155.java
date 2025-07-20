import java.util.*;

public class Contest155 {
    public String findCommonResponse(List<List<String>> responses) {
        HashMap<String, Integer> map = new HashMap<>();
        String res = "";
        int max = 0;

        for (List<String> response : responses) {
            Set<String> set = new HashSet<>(response);
            for (String s : set) {
                map.put(s, map.getOrDefault(s, 0) + 1);
                if (max < map.get(s)) {
                    max = map.get(s);
                    res = s;
                } else if (max == map.get(s) && res.compareTo(s) > 0) {
                    res = s;
                }
            }
        }
        return res;
    }

//    public int[] baseUnitConversions(int[][] conversions) {
//        int MOD = 1000000007;
//        int n = conversions.length + 1;
//        List<List<Pair<Integer, Integer>>> graph = new ArrayList<>(n);
//        for (int i = 0; i < n; i++) {
//            graph.add(new ArrayList<>());
//        }
//
//        for (int[] conv : conversions) {
//            int u = conv[0];
//            int v = conv[1];
//            int factor = conv[2];
//            graph.get(u).add(new Pair<>(v, factor));
//        }
//
//        int[] res = new int[n];
//        res[0] = 1;
//
//        Queue<Integer> q = new LinkedList<>();
//        q.offer(0);
//
//        while (!q.isEmpty()) {
//            int u = q.poll();
//            for (Pair<Integer, Integer> edge : graph.get(u)) {
//                int v = edge.getKey();
//                int factor = edge.getValue();
//                if (res[v] == 0) {
//                    res[v] = (int) (((long) res[u] * factor) % MOD);
//                    q.offer(v);
//                }
//            }
//        }
//
//        return res;
//    }

    public int countCells(char[][] grid, String pattern) {
        int m = grid.length, n = grid[0].length;
        int k = pattern.length();

        StringBuilder hBuilder = new StringBuilder();
        for (char[] row : grid) {
            hBuilder.append(row);
        }
        String h = hBuilder.toString();

        StringBuilder vBuilder = new StringBuilder();
        for (int j = 0; j < n; j++) {
            for (char[] chars : grid) {
                vBuilder.append(chars[j]);
            }
        }
        String v = vBuilder.toString();

        List<Integer> hOccurrences = findAllOccurrencesKMP(h, pattern);
        List<Integer> vOccurrences = findAllOccurrencesKMP(v, pattern);

        int[] horizontal = new int[m * n + 1];
        for (int s : hOccurrences) {
            int end = s + k;
            if (end <= m * n) {
                horizontal[s]++;
                horizontal[end]--;
            }
        }
        int[] prefix_h = new int[m * n];
        int current_h = 0;
        for (int i = 0; i < m * n; i++) {
            current_h += horizontal[i];
            prefix_h[i] = current_h;
        }

        // Vertical
        int[] vertical = new int[m * n + 1];
        for (int s : vOccurrences) {
            int end = s + k;
            if (end <= m * n) {
                vertical[s]++;
                vertical[end]--;
            }
        }
        int[] prefix_v = new int[m * n];
        int current_v = 0;
        for (int i = 0; i < m * n; i++) {
            current_v += vertical[i];
            prefix_v[i] = current_v;
        }

        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                int idx_h = i * n + j;
                if (idx_h >= m * n) {
                    continue;
                }
                if (prefix_h[idx_h] <= 0) {
                    continue;
                }
                int idx_v = j * m + i;
                if (idx_v >= m * n) {
                    continue;
                }
                if (prefix_v[idx_v] > 0) {
                    count++;
                }
            }
        }

        return count;
    }

    public List<Integer> findAllOccurrencesKMP(String main, String pattern) {
        List<Integer> occurrences = new ArrayList<>();
        int n = main.length(), m = pattern.length();

        if (m == 0) {
            for (int i = 0; i <= n; i++) {
                occurrences.add(i);
            }
            return occurrences;
        }

        int[] lps = computeLPSArray(pattern);
        int i = 0, j = 0;

        while (i < n) {
            if (pattern.charAt(j) == main.charAt(i)) {
                j++;
                i++;
            }
            if (j == m) {
                occurrences.add(i - j);
                j = lps[j - 1];
            } else if (i < n && pattern.charAt(j) != main.charAt(i)) {
                if (j != 0) {
                    j = lps[j - 1];
                } else {
                    i++;
                }
            }
        }
        return occurrences;
    }

    private int[] computeLPSArray(String pattern) {
        int m = pattern.length();
        int[] lps = new int[m];
        int length = 0;
        int i = 1;
        lps[0] = 0;

        while (i < m) {
            if (pattern.charAt(i) == pattern.charAt(length)) {
                length++;
                lps[i] = length;
                i++;
            } else {
                if (length != 0) {
                    length = lps[length - 1];
                } else {
                    lps[i] = 0;
                    i++;
                }
            }
        }
        return lps;
    }
}
