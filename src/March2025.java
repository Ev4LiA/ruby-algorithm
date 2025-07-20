import java.util.List;

public class March2025 {
    public void operation(int[] nums, int n) {
        int min_sum = Integer.MAX_VALUE;
        int index = -1;
        for (int i = 0; i < n - 1; i++) {
            if (nums[i] + nums[i + 1] < min_sum) {
                min_sum = nums[i] + nums[i + 1];
                index = i;
            }
        }

        nums[index] = min_sum;
        for (int i = index + 1; i < n - 1; i++) {
            nums[i] = nums[i + 1];
        }
    }

    public int minimumPairRemoval(int[] nums) {
        int res = 0, n = nums.length;
        for (int i  = 0; i < nums.length - 1; i++) {
            if (nums[i] > nums[i + 1]) {
                res++;
                i = -1;
                operation(nums, n);
                n--;
            }
        }
        return res;
    }
}
