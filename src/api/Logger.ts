export class Logger {
  static debug(data): void {
    this.write("debug", data);
  }

  static info(data): void {
    this.write("info", data);
  }

  static error(data): void {
    this.write("error", data);
  }

  private static async write(level, data): Promise<void> {
    console[level](data);
  }
}
