const path = require("path")
const glob = require("glob")
const BrowserSyncPlugin = require("browser-sync-webpack-plugin")
const HtmlWebpackPlugin = require("html-webpack-plugin")
const MiniCssExtractPlugin = require("mini-css-extract-plugin")
const PurgecssPlugin = require("purgecss-webpack-plugin")
const OptimizeCssAssetsPlugin = require("optimize-css-assets-webpack-plugin")

module.exports = (env, argv) => {
    return {
        // default:
        // entry: './src/index.js',
        output: {
            path: path.resolve(__dirname, "public")
        },
        optimization: {
            splitChunks: {
                cacheGroups: {
                    styles: {
                        name: "styles",
                        test: /\.css$/,
                        chunks: "all",
                        enforce: true,
                    },
                },
            },
            minimizer: [new OptimizeCssAssetsPlugin()]
        },
        module: {
            rules: [
                {
                    test: /\.css$/,
                    use: [
                        MiniCssExtractPlugin.loader,
                        // "style-loader",
                        "css-loader",
                        {
                            loader: "postcss-loader",
                            options: {
                                ident: "postcss",
                                plugins: [
                                    require("tailwindcss"),
                                    require("autoprefixer"),
                                ],
                            },
                        },
                    ],
                },
                {
                    test: /\.(png|jpe?g|gif|ico)$/,
                    use: [
                        {
                            loader: "file-loader",
                            options: {
                                name: '[path][name].[ext]',
                            },
                        },
                    ],
                },
            ]
        },
        plugins: [
            new BrowserSyncPlugin({
                host: "localhost",
                port: 3000,
                proxy: "http://localhost:3100"
            }, {
                reload: false
            }),
            new HtmlWebpackPlugin({
                name: "Arvin Sevilla",
                title: "Software Engineer",
                template: "src/index.html"
            }),
            new MiniCssExtractPlugin({
                filename: "[name].css",
                chunkFilename: "[id].css",
            }),
            ...argv.mode === "production"
                ? [new PurgecssPlugin({
                    paths: glob.sync(`${path.resolve(__dirname, "src")}/**/*`, {nodir: true}),
                    defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || [],
                })]
                : [],
        ],
        devServer: {
            port: 3100,
        },
    }
}
