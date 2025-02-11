import time

def main():
    print("Hello, Jenkins!")
    for i in range(5):
        print(f"Processing... {i+1}/5")
        time.sleep(1)
    print("Done!")

if __name__ == "__main__":
    main()
