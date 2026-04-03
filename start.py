from ultralytics import YOLO

def main():
    # 1. 加载模型
    model = YOLO("yolo11n.pt")

    # 2. 开始训练
    # 所有的训练逻辑必须放在 main() 函数或 if __name__ == '__main__': 内部
    results = model.train(data="coco8.yaml", epochs=100, imgsz=640)

    # 3. 运行推理
    # 注意：这里路径前加了 r，避免上次提到的转义字符问题
    results = model(r"train_data\数据集\Uncracked\Uncracked (609).png")

if __name__ == '__main__':
    main()