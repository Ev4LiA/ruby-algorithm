class ArrayString
  # 88. Merge Sorted Array# @param {Integer[]} nums1
  # @param {Integer} m
  # @param {Integer[]} nums2
  # @param {Integer} n
  # @return {Void} Do not return anything, modify nums1 in-place instead.
  def merge(nums1, m, nums2, n)
    a = m - 1
    b = n - 1

    (m + n - 1).downto(0) do |k|
      break if b == - 1

      if nums1[a] > nums2[b] && a >= 0
        nums1[k] = nums1[a]
        a -= 1
      else
        nums1[k] = nums2[b]
        b -= 1
      end
    end
    nil
  end
end
