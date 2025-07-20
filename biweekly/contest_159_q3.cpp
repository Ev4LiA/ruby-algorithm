#include <bits/stdc++.h>
using namespace std;

class Solution {
public:
    long long primeSubarray(vector<int>& nums, int k) {
        if (nums.size() < 2) return 0;

        int maxVal = *max_element(nums.begin(), nums.end());
        vector<bool> isPrime(maxVal + 1, true);
        if (maxVal >= 0)  isPrime[0] = false;
        if (maxVal >= 1)  isPrime[1] = false;
        for (int p = 2; 1LL * p * p <= maxVal; ++p) {
            if (!isPrime[p]) continue;
            for (long long q = 1LL * p * p; q <= maxVal; q += p)
                isPrime[q] = false;
        }

        deque<int> minQ, maxQ;
        deque<int> primeIdx;
        int left = 0;
        long long ans = 0;

        for (int right = 0; right < (int)nums.size(); ++right) {
            int val = nums[right];

            if (isPrime[val]) {
                while (!minQ.empty() && minQ.back() > val) minQ.pop_back();
                minQ.push_back(val);

                while (!maxQ.empty() && maxQ.back() < val) maxQ.pop_back();
                maxQ.push_back(val);

                primeIdx.push_back(right);
            }

            while (!minQ.empty() && maxQ.front() - minQ.front() > k) {
                if (isPrime[nums[left]]) {
                    if (nums[left] == minQ.front()) minQ.pop_front();
                    if (nums[left] == maxQ.front()) maxQ.pop_front();
                    if (primeIdx.front() == left)   primeIdx.pop_front();
                }
                ++left;
            }

            if (primeIdx.size() >= 2) {
                int secondLastPrimeIdx = primeIdx[primeIdx.size() - 2];
                ans += secondLastPrimeIdx - left + 1;
            }
        }

        return ans;
    }
};