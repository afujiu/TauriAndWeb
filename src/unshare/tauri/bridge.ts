export const bootMode = 'tauri'
/**
 * コマンド実行用ブリッジ (Tauri 版)
 * @param command 実行するコマンド名
 * @param args コマンドに渡す引数
 * @returns コマンドの実行結果
 */
export async function bridge<T>(command: string, args: any): Promise<T> {
  const { invoke } = await import('@tauri-apps/api/core')
	console.log('unshare/tauri/ああ')
  return await invoke<T>(command, args)
}
