export const bootMode = 'web'

// 開発モードではフロントエンドの dev サーバーではなくバックエンド (http://localhost:8080) を呼ぶ
const base = (typeof import.meta !== 'undefined' && (import.meta as any).env && (import.meta as any).env.DEV) ? 'http://localhost:8080' : ''
/**
 * Web の場合は restapi を使用し、Web 環境の場合は fetch を使用して API を呼び出す抽象化関数
 * @param command 実行するコマンド名
 * @param args コマンドに渡す引数
 * @returns コマンドの実行結果
 */
export async function bridge<T>(command: string, args: any): Promise<T> {
    // Web 環境の場合は API サーバーを呼び出す
    const url = `${base}/api/${command}`
    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(args),
    })
    const data = await response.json()
    // result フィールドがあればそれを返し、なければ message を返す（互換性のため）
    return (data.result !== undefined ? data.result : data.message) as T
}