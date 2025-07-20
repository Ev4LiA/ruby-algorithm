import java.util.*;

class Solution {
    public long sumOfLargestPrimes(String s) {
        Set<Integer> primes = new HashSet<>();
        
        // Generate all substrings and check for primes
        for (int i = 0; i < s.length(); i++) {
            for (int j = i + 1; j <= s.length(); j++) {
                String substring = s.substring(i, j);
                int num = Integer.parseInt(substring); // Automatically handles leading zeros
                if (isPrime(num)) {
                    primes.add(num);
                }
            }
        }
        
        // Convert to list and sort in descending order
        List<Integer> primeList = new ArrayList<>(primes);
        primeList.sort(Collections.reverseOrder());
        
        // Sum the first 3 (or fewer if less than 3 exist)
        long sum = 0;
        for (int i = 0; i < Math.min(3, primeList.size()); i++) {
            sum += primeList.get(i);
        }
        
        return sum;
    }
    
    private boolean isPrime(int n) {
        if (n <= 1) return false;
        if (n <= 3) return true;
        if (n % 2 == 0 || n % 3 == 0) return false;
        
        // Check for factors of the form 6k ± 1
        for (int i = 5; i * i <= n; i += 6) {
            if (n % i == 0 || n % (i + 2) == 0) {
                return false;
            }
        }
        return true;
    }
}