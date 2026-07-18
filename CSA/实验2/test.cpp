#include <iostream>
#include <iomanip>

class ArrayProcessor
{
private:
	static const int ELEMENT_COUNT = 60;
	int arrayA[ELEMENT_COUNT];
	int arrayB[ELEMENT_COUNT];
	int arrayC[ELEMENT_COUNT];
	int arrayD[ELEMENT_COUNT];

	// 计算数组A和B的值
	void computeArrayAandB()
	{
		arrayA[0] = 0;
		arrayB[0] = 1;

		for (int idx = 1; idx < ELEMENT_COUNT; idx++)
		{
			arrayA[idx] = arrayA[idx - 1] + idx;
			arrayB[idx] = arrayB[idx - 1] + 3 * idx;
		}
	}

	// 根据索引范围计算数组C和D
	void computeArrayCandD()
	{
		for (int idx = 0; idx < ELEMENT_COUNT; idx++)
		{
			computeForIndex(idx);
		}
	}

	// 处理单个索引
	void computeForIndex(int idx)
	{
		if (idx < 20)
		{
			handleFirstRange(idx);
		}
		else if (idx < 40)
		{
			handleSecondRange(idx);
		}
		else
		{
			handleThirdRange(idx);
		}
	}

	void handleFirstRange(int idx)
	{
		arrayC[idx] = arrayA[idx];
		arrayD[idx] = arrayB[idx];
	}

	void handleSecondRange(int idx)
	{
		arrayC[idx] = arrayA[idx] + arrayB[idx];
		arrayD[idx] = arrayA[idx] * arrayC[idx];
	}

	void handleThirdRange(int idx)
	{
		arrayC[idx] = arrayA[idx] * arrayB[idx];
		arrayD[idx] = arrayC[idx] * arrayB[idx];
	}

	// 显示结果
	void displayResults() const
	{
		std::cout << "数组元素值如下：" << std::endl;
		std::cout << "索引   数组A      数组B      数组C      数组D" << std::endl;

		for (int idx = 0; idx < ELEMENT_COUNT; idx++)
		{
			displayRow(idx);
		}
	}

	void displayRow(int idx) const
	{
		std::cout << "i=" << std::setw(2) << idx << "    "
				  << formatHex(arrayA[idx]) << "    "
				  << formatHex(arrayB[idx]) << "    "
				  << formatHex(arrayC[idx]) << "    "
				  << formatHex(arrayD[idx]) << std::endl;
	}

	std::string formatHex(int value) const
	{
		std::stringstream ss;
		ss << std::hex << std::setw(8) << std::setfill('0') << value;
		return ss.str();
	}

public:
	void process()
	{
		computeArrayAandB();
		computeArrayCandD();
		displayResults();
	}
};

int main()
{
	ArrayProcessor processor;
	processor.process();
	return 0;
}