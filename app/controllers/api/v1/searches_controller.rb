module Api
  module V1
    class SearchesController < ApplicationController
      # GET /products
      def index
        @wakeup = {"message" : "api wake up!"}
        #@products = Product.order("RANDOM()").limit(15)
        render json: @wakeup
      end

      def create
        @first = 1 #First
        @displayItem = params[:displayItem] #表示件数

        @mode = params[:mode] # modeで処理の場合分け
        #mode : all, paging, genre
        #modeのlengthを確認する1ならallもしくは、paging,2以上なら複合検索、
        #pagingは数字が入っており、その数を次のcurrentPageに設定する。
        #currentPage,表示件数、ページ総数を計算してPageObjectを作成する。
        #currentPageに表示する検索結果をpuroducts配列へ送る
        #order : asc
        #current : 1

        if @mode == "all" 
          @count = Product.all.size
        elsif @mode == "nigiri"
          @count = Product.where(genre: "nigiri").size
        elsif @mode == "kaisen"
          @count = Product.where(genre: "kaisen").size
        elsif @mode == "siru"
          @count = Product.where(genre: "siru").size 
        elsif @mode == "sousaku"
          @count = Product.where(genre: "sousaku").size
        elsif @mode == "select"
          @select = params[:select]
          @keyword = params[:keyword]
          if @select != "" && @keyword != ""
            @count = Product.where(genre: @select).where("name LIKE ?","%#{@keyword}%").size
          elsif @select == "" && @keyword != ""
            @count = Product.where("name LIKE ?","%#{@keyword}%").size
          elsif @select != "" && @keyword == ""
            @count = Product.where(genre: @select).size
          elsif @select == "" && @keyword == ""
            @count = Product.all.size
          end
        end

        # Lastページの時だけ-1を実際の最終ページの数値に置き換え
        # current = 1の際はこのブロックは処理されない
        if params[:current] != -1
          @current = params[:current] #Current
        elsif params[:current] == -1
          if @count % @displayItem == 0
            @current = @count / @displayItem #Last
          else
            @current =@count / @displayItem +1  
          end 
        end

        # prebとnextに数値代入
        @preb = @current - 1 # Preb
        @next = @current + 1 # Next

        #ここでラストページの数値代入
        if @count % @displayItem == 0
          @Last = @count / @displayItem #Last
        else
          @Last = @count / @displayItem +1
        end

        # puts @count
        # puts @Last

        @startId = (@current - 1) * @displayItem
        if @mode == "all"
        @products = Product.all.limit(@displayItem).offset(@startId)
        elsif @mode == "nigiri"
        @products = Product.where(genre: "nigiri").limit(@displayItem).offset(@startId)
        elsif @mode == "kaisen"
        @products = Product.where(genre: "kaisen").limit(@displayItem).offset(@startId)
        elsif @mode == "siru"
        @products = Product.where(genre: "siru").limit(@displayItem).offset(@startId)
        elsif @mode == "sousaku"
        @products = Product.where(genre: "sousaku").limit(@displayItem).offset(@startId)
        elsif @mode == "select"
          @select = params[:select]
          @keyword = params[:keyword]
          if @select != "" && @keyword != ""
            @products = Product.where(genre: @select).where("name LIKE ?","%#{@keyword}%").limit(@displayItem).offset(@startId)
          elsif @select == "" && @keyword != ""
            @products = Product.where("name LIKE ?","%#{@keyword}%").limit(@displayItem).offset(@startId)
          elsif @select != "" && @keyword == ""
            @products = Product.where(genre: @select).limit(@displayItem).offset(@startId)
          elsif @select == "" && @keyword == ""
            @products = Product.all.limit(@displayItem).offset(@startId)
          end
        end

        

        #currentがFirstとLastでは無いケース
        if @current != 1 && @current != -1 && @current != @Last
          @preparation_ary = [
            @first, @preb, @current, @next, @Last
        ]
          @duplicate_ary = @preparation_ary.uniq

          
          if @duplicate_ary[0] - @duplicate_ary[1] == -2
            @duplicate_ary.insert(1,2)
          elsif @duplicate_ary[0] - @duplicate_ary[1] <= -3
            @duplicate_ary.insert(1,"...")
          end

          if @duplicate_ary[-1] - @duplicate_ary[-2] == 2
            @duplicate_ary.insert(-2,(@duplicate_ary[-1]-1))
          elsif @duplicate_ary[-1] - @duplicate_ary[-2] >= 3
            @duplicate_ary.insert(-2,"...")
          end

        end
        #currentが１のケース
        if @current ==1
          @diff = @Last - 1
          case @diff
          when 0 then @duplicate_ary = [1]
          when 1 then @duplicate_ary = [1, 2]
          when 2 then @duplicate_ary = [1, 2, 3]
          when 3 then @duplicate_ary = [1, 2, 3, 4]
          when 4 then @duplicate_ary = [1, 2, 3, 4, 5]
          when 6 then @duplicate_ary = [1, 2, 3, "...", 6]
          else 
            @duplicate_ary = [1,2,3,"...",@Last]
          end

        elsif @current == -1 || @current == @Last
          @diff = @Last - 1
          case @diff
          when 0 then @duplicate_ary = [1]
          when 1 then @duplicate_ary = [1, 2]
          when 2 then @duplicate_ary = [1, 2, 3]
          when 3 then @duplicate_ary = [1, 2, 3, 4]
          when 4 then @duplicate_ary = [1, 2, 3, 4, 5]
          when 6 then @duplicate_ary = [1, "..." , 4, 5, 6]
          else 
            @duplicate_ary = [1,"...",@Last-2,@Last-1,@Last]
          end
        end
        

        @products_info = {
          current: @current,
          pageAry: @duplicate_ary,
          products: @products,
          mode:@mode,
          displayItem:@displayItem,
          lastPage: @Last,
          keyword: @keyword,
          select: @select,
        }
        render json: @products_info
      end
    end
  end
end
