# blasmat

![image](image.png)

## 概要
- Gauche で、OpenBLAS ライブラリ を使って行列の高速演算を行うためのモジュールです。  
  OpenBLAS は、C/Fortran で書かれた線形代数用のライブラリです ( https://www.openblas.net )。  
  現状、本モジュールは、標準の gauhce.array モジュールにおける  
  2次元の f64array の ごく一部の演算のみが可能です。


## インストール方法
1. Gauche のインストール  
   事前に Gauche がインストールされている必要があります。  
   Windows の場合は、以下のページに Windows用バイナリインストーラ があるので  
   インストールを実施ください。  
   http://practical-scheme.net/gauche/download-j.html  
   (すでにインストール済みであれば本手順は不要です)

2. 開発環境のインストール  
   C と C++ の開発環境が必要です。  
   Windows の場合は、以下のページを参考に、MSYS2/MinGW-w64 (64bit/32bit) の  
   開発環境をインストールしてください。  
   https://gist.github.com/Hamayama/eb4b4824ada3ac71beee0c9bb5fa546d  
   (すでにインストール済みであれば本手順は不要です)

3. OpenBLAS ライブラリ のインストール  
   OpenBLAS のホームページ ( https://www.openblas.net ) 等を参照して、  
   OpenBLAS ライブラリのインストールを実施ください。  
   Windows の場合は、以下のように実行してください。  
   ＜MSYS2/MinGW-w64 (64bit) 環境の場合＞  
   プログラムメニューから MSYS2 の MinGW 64bit Shell を起動して、以下のコマンドを実行します。
   ```
     pacman -S mingw-w64-x86_64-openblas
   ```
   ＜MSYS2/MinGW-w64 (32bit) 環境の場合＞  
   プログラムメニューから MSYS2 の MinGW 32bit Shell を起動して、以下のコマンドを実行します。
   ```
     pacman -S mingw-w64-i686-openblas
   ```

4. ファイルのダウンロード  
   本サイト ( https://github.com/Hamayama/blasmat ) のソースを、  
   (Download Zip ボタン等で) ダウンロードして、作業用のフォルダに展開してください。  
   例えば、作業用のフォルダを c:\work とすると、  
   c:\work\blasmat の下にファイル一式が配置されるように展開してください。  
   (注意) 作業用フォルダのパスには、空白を入れないようにしてください。

5. コンパイルとインストール  
   展開したフォルダで、./configure と make install を実行して、  
   インストールを実施ください。  
   Windows の場合は、以下のように実行してください。  
   ＜MSYS2/MinGW-w64 (64bit) 環境の場合＞  
   プログラムメニューから MSYS2 の MinGW 64bit Shell を起動して、以下のコマンドを実行します。  
   ＜MSYS2/MinGW-w64 (32bit) 環境の場合＞  
   プログラムメニューから MSYS2 の MinGW 32bit Shell を起動して、以下のコマンドを実行します。  
   ( c:\work にソースを展開した場合)
   ```
     cd /c/work/blasmat
     ./configure   # Makefile等を生成します
     make          # コンパイルを実行します
     make install  # Gaucheのライブラリフォルダにインストールします
     make check    # テストを実行します
   ```
   (注意) Windows の環境によっては、make install を実行すると  
   「*** ERROR: mkstemp failed」というエラーが発生します。  
   このエラーは、インストール先のフォルダに書き込み権限がないとき等に発生します。  
   その場合には、プログラムメニューからの開発環境の起動時に右クリックして、  
   「管理者として実行」を選択してください。  
   そして再度上記のコマンドを実行してください。

- 以上です。


## 使い方
- 基本的な使い方は、以下のようになります。
  ```
    (use gauche.array)        ; 標準の行列演算モジュールをロードします。
    (use blasmat)             ; 本モジュールをロードします。
    (define A (f64array (shape 0 2 0 2) 1 2 3 4))     ; 2x2 の 行列A を作成します。
    (define B (f64array (shape 0 2 0 2) 5 6 7 8))     ; 2x2 の 行列B を作成します。
    (define C (f64array (shape 0 2 0 2) 10 20 30 40)) ; 2x2 の 行列C を作成します。
    (blas-array-dgemm A B C 1.0 1.0))                 ; C = AB + C を計算します。
    (print C)                 ; 行列C の内容を表示します。
    (print (array-ref C 0 0)) ; 行列C の左上の要素の値を表示します。
    (print (array-ref C 0 1)) ; 行列C の右上の要素の値を表示します。
  ```
- 使用可能な手続きを、以下に示します。  
  (現状、本モジュールは、標準の gauhce.array モジュールにおける  
  2次元の f64array の ごく一部の演算のみが可能です。)

  - `(blas-array-daxpy A B alpha)`  
    行列A, B と 実数alpha に対して、  
    B = alpha A + B を計算して返します (行列B は変更されます)。

  - `(blas-array-dgemm A B C alpha beta)`  
    行列A, B, C と 実数alpha, beta に対して、  
    C = alpha A B + beta C を計算して返します (行列C は変更されます)。


## 注意事項
1. 本モジュールは、標準の gauche.array モジュールにおける  
   `<f64array>` クラスの内部情報 (backing-storage スロット等) を使用しています。  
   このため、Gauche の将来の変更で動作しなくなる可能性があります。


## 環境等
- OS
  - Windows 8.1 (64bit)
- 環境
  - MSYS2/MinGW-w64 (64bit/32bit) (gcc version 7.3.0 (Rev2, Built by MSYS2 project))
- 言語
  - Gauche v0.9.7
- ライブラリ
  - OpenBLAS v0.3.0

## 履歴
- 2019-3-17  v1.00 (初版)


(2019-3-17)
