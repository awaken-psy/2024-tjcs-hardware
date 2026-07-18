// 鸡蛋耐摔测试模拟程序
// 使用二分查找算法确定鸡蛋的耐摔临界楼层
// 同时计算不同经济时期的成本消耗
#include <cstdio>

int main()
{
    // 初始化参数输入
    int total_building_floors;
    int egg_durability_threshold;

    // 获取用户输入的初始参数
    printf("请输入建筑总楼层数：");
    scanf("%d", &total_building_floors);

    printf("请输入鸡蛋耐摔阈值：");
    scanf("%d", &egg_durability_threshold);

    // 测试过程变量
    int total_test_attempts = 0;
    int broken_eggs_count = 0;
    bool final_test_broken_status = false;
    
    // 移动楼层统计
    int upward_movement = 0, downward_movement = 0;
    int previous_test_floor = (total_building_floors + 1) / 2;
    
    // 搜索边界
    int search_lower_bound = 0;
    int search_upper_bound = total_building_floors;
    
    // 成本计算结果
    int resource_scarcity_cost = 0;
    int labor_intensive_cost = 0;

    // 二分查找算法执行
    while (search_lower_bound < search_upper_bound) {
        total_test_attempts++;

        // 计算当前测试楼层
        int current_test_floor = (search_lower_bound + search_upper_bound + 1) / 2;
        
        // 计算楼层移动距离并累加
        if (current_test_floor > previous_test_floor) {
            upward_movement += (current_test_floor - previous_test_floor);
        } else {
            downward_movement += (previous_test_floor - current_test_floor);
        }

        // 执行耐摔测试
        if (current_test_floor > egg_durability_threshold) {
            // 鸡蛋摔碎的情况
            final_test_broken_status = true;
            search_upper_bound = current_test_floor - 1;
            broken_eggs_count++;
        } else {
            // 鸡蛋完好的情况
            final_test_broken_status = false;
            search_lower_bound = current_test_floor;
        }
        
        // 更新上次测试楼层记录
        previous_test_floor = current_test_floor;
    }

    // 成本计算模型
    // 资源匮乏期：物资成本权重高，人工成本权重低
    resource_scarcity_cost = 2 * upward_movement + downward_movement + 4 * broken_eggs_count;
    
    // 人力成本增长期：人工成本权重高，物资成本权重低
    labor_intensive_cost = 4 * upward_movement + downward_movement + 2 * broken_eggs_count;

    // 测试结果输出
    printf("总计进行测试次数：%d次，摔碎鸡蛋数量：%d个，", 
           total_test_attempts, broken_eggs_count);
    printf("最后一次测试鸡蛋");
    printf(final_test_broken_status ? "已摔碎\n" : "保持完好\n");
    
    printf("累计上行楼层数：%d层，累计下行楼层数：%d层\n", 
           upward_movement, downward_movement);
    
    printf("资源匮乏时期总成本（十六进制）：0x%x，", resource_scarcity_cost);
    printf("人力成本增长期总成本（十六进制）：0x%x\n", labor_intensive_cost);
    
    return 0;
}
